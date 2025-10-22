const fs = require('fs');
const path = require('path');

try {
  // Caminho padrão onde o Salesforce CLI salva os resultados
  const resultsDir = path.join('.sf', 'test-results', 'apex');
  if (!fs.existsSync(resultsDir)) {
    console.error(`❌ Test results directory not found: ${resultsDir}`);
    process.exit(1);
  }

  // Encontra o arquivo de resultado mais recente
  const files = fs.readdirSync(resultsDir)
    .filter(f => f.startsWith('test-result-') && f.endsWith('.json'))
    .map(f => ({ name: f, time: fs.statSync(path.join(resultsDir, f)).mtime }))
    .sort((a, b) => b.time - a.time);

  if (files.length === 0) {
    console.error("❌ No test result JSON files found in the test results directory.");
    process.exit(1);
  }

  const latestFile = path.join(resultsDir, files[0].name);
  console.log(`🧾 Using test result file: ${latestFile}`);

  const data = fs.readFileSync(latestFile, 'utf8');
  const json = JSON.parse(data);

  if (!json.result || !json.result.coverage || !json.result.coverage.coverage) {
    console.error("❌ Could not find coverage data in the test result file.");
    process.exit(1);
  }

  const coverages = json.result.coverage.coverage;
  let totalCovered = 0;
  let totalLines = 0;

  coverages.forEach(c => {
    totalCovered += c.numLocations - c.numLocationsNotCovered;
    totalLines += c.numLocations;
  });

  const percentage = ((totalCovered / totalLines) * 100).toFixed(2);
  console.log(`📊 Total coverage: ${percentage}%`);

  if (percentage < 75) {
    console.error("❌ Coverage below 75%. Pipeline failed.");
    process.exit(1);
  } else {
    console.log("✅ Minimum coverage requirement met.");
  }

} catch (err) {
  console.error("❌ Error checking coverage:", err);
  process.exit(1);
}