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

  // Se o JSON for um array, tenta encontrar os objetos com cobertura
  const possibleEntries = Array.isArray(json) ? json : [json];

  let coverages = [];

  possibleEntries.forEach(entry => {
    // existing expected shapes
    if (entry.coverage?.coverage) {
      coverages.push(...entry.coverage.coverage);
    } else if (entry.result?.coverage?.coverage) {
      coverages.push(...entry.result.coverage.coverage);
    } else if (entry.tests) {
      entry.tests.forEach(t => {
        if (t.coverage?.coverage) {
          coverages.push(...t.coverage.coverage);
        }
      });
    } else if (entry.totalLines && entry.lines) {
      // New: handle per-class coverage objects like your sample
      const linesMap = entry.lines || {};
      // Count covered lines: values > 0
      const coveredCount = Object.values(linesMap).filter(v => Number(v) > 0).length;
      const numLocations = Number(entry.totalLines) || Object.keys(linesMap).length;
      const numLocationsNotCovered = Math.max(0, numLocations - coveredCount);
      coverages.push({
        numLocations: numLocations,
        numLocationsNotCovered: numLocationsNotCovered,
      });
    }
  });

  if (!coverages.length) {
    console.error('❌ Could not find coverage data in the test result file.');
    console.log('🧩 First JSON entry sample:', JSON.stringify(possibleEntries[0], null, 2).substring(0, 800));
    process.exit(1);
  }

  let totalCovered = 0;
  let totalLines = 0;

  coverages.forEach(c => {
    // defensive coercion
    const numLocations = Number(c.numLocations) || 0;
    const numNotCovered = Number(c.numLocationsNotCovered) || 0;
    totalCovered += Math.max(0, numLocations - numNotCovered);
    totalLines += numLocations;
  });

  if (totalLines === 0) {
    console.error('❌ No measurable lines found in coverage data.');
    process.exit(1);
  }

  const percentage = ((totalCovered / totalLines) * 100);
  const percentageStr = percentage.toFixed(2);
  console.log(`📊 Total coverage: ${percentageStr}%`);

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