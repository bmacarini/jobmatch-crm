const fs = require('fs');
const path = require('path');

try {
  // Busca o arquivo de resultado de teste na pasta atual
  const files = fs.readdirSync('.');
  const coverageFile = files.find(f => f.startsWith('test-result-') && f.endsWith('.json'));

  if (!coverageFile) {
    console.error("No test-result JSON file found in the root directory.");
    process.exit(1);
  }

  const data = fs.readFileSync(path.join('.', coverageFile), 'utf8');
  const json = JSON.parse(data);

  if (!json.result || !json.result.coverage) {
    console.error("Could not find coverage data in the test result file.");
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

  console.log(`Total coverage: ${percentage}%`);

  if (percentage < 75) {
    console.error("Coverage below 75%. Pipeline failed.");
    process.exit(1);
  } else {
    console.log("Minimum coverage requirement met.");
  }

} catch (err) {
  console.error("❌ Error checking coverage:", err);
  process.exit(1);
}