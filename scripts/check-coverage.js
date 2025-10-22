const fs = require('fs');

try {
  const data = fs.readFileSync('coverage.json', 'utf8');
  const json = JSON.parse(data);

  if (!json.result || !json.result.coverage) {
    console.error("Não foi possível encontrar dados de cobertura no arquivo coverage.json");
    process.exit(1);
  }

  // Soma da cobertura de todas as classes
  const coverages = json.result.coverage.coverage;
  let totalCovered = 0;
  let totalLines = 0;

  coverages.forEach(c => {
    totalCovered += c.numLocations - c.numLocationsNotCovered;
    totalLines += c.numLocations;
  });

  const percentage = ((totalCovered / totalLines) * 100).toFixed(2);

  console.log(`📊 Cobertura total: ${percentage}%`);

  if (percentage < 75) {
    console.error("Cobertura abaixo de 75%. Pipeline falhou.");
    process.exit(1);
  } else {
    console.log("Cobertura mínima atingida.");
  }

} catch (err) {
  console.error("Erro ao verificar cobertura:", err);
  process.exit(1);
}