const fs = require('fs');
const path = require('path');

try {
  const resultsDir = '.sf/test-results/apex';
  if (!fs.existsSync(resultsDir)) {
    console.error(`❌ Test results directory not found: ${resultsDir}`);
    process.exit(1);
  }

  const files = fs.readdirSync(resultsDir).filter(f => f.endsWith('.json'));
  if (files.length === 0) {
    console.error(`❌ No JSON files found in ${resultsDir}`);
    process.exit(1);
  }

  // Encontra o arquivo mais recente
  const latestFile = files
    .map(f => ({
      name: f,
      time: fs.statSync(path.join(resultsDir, f)).mtime.getTime(),
    }))
    .sort((a, b) => b.time - a.time)[0].name;

  console.log(`🧾 Using test result file: ${path.join(resultsDir, latestFile)}`);

  const data = fs.readFileSync(path.join(resultsDir, latestFile), 'utf8');
  const json = JSON.parse(data);

  // Tenta achar dados de cobertura em diferentes estruturas possíveis
  const coverages =
    json.coverage?.coverage ||
    json.result?.coverage?.coverage ||
    json.tests?.flatMap(t => t.coverage?.coverage || []) ||
    [];

  if (!coverages.length) {
    console.error('❌ Could not find coverage data in the test result file.');
    console.log('🔍 JSON keys available:', Object.keys(json));
    process.exit(1);
  }

  let totalCovered = 0;
  let totalLines = 0;

  coverages.forEach(c => {
    totalCovered += c.numLocations - c.numLocationsNotCovered;
    totalLines += c.numLocations;
  });

  const percentage = ((totalCovered / totalLines) * 100).toFixed(2);
  console.log(`📊 Total coverage: ${percentage}%`);

  if (percentage < 75) {
    console.error('🚨 Coverage below 75%. Pipeline failed.');
    process.exit(1);
  } else {
    console.log('✅ Minimum coverage requirement met.');
  }
} catch (err) {
  console.error('❌ Error checking coverage:', err);
  process.exit(1);
}