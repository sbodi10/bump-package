#!/usr/bin/env node
const readline = require('readline');
const fs = require('fs');
const inquirer = require('inquirer');
const packageJSONPath = process.cwd() + '/package.json';

const getCurrentPackageVersion = () => {
	const packageJSONFile = JSON.parse(fs.readFileSync(packageJSONPath));
    return packageJSONFile.version;
}

const selectUpdateType = async () => {
	const currentVersionNumber = getCurrentPackageVersion();
	const splitVersionValues = currentVersionNumber.split('.');

    const majorNumber = splitVersionValues[0];
    const minorNumber = splitVersionValues[1];
    const patchNumber = splitVersionValues[2];

	const majorVersionBump = (Number(majorNumber) + 1).toString() + '.0.0';
	const minorVersionBump = majorNumber.toString() + '.' + (Number(minorNumber) + 1).toString() + '.' + patchNumber.toString();
	const patchVersionBump = majorNumber.toString() + '.' + minorNumber.toString() + '.' + (Number(patchNumber) + 1).toString();
	return new Promise((resolve, reject) => {
		inquirer.prompt([
			{
				type: 'list',
				name: 'version',
				message: 'What type of bump would you like to make?',
				choices: [
					`Major (${majorVersionBump})`,
					`Minor ${minorVersionBump}`,
					`Patch ${patchVersionBump}`
				]
			}
		]).then(answer => {
            const data = JSON.stringify(answer);
            // fs.writeFileSync(packageJSONPath, data);
		});
	});
};

const main = async () => {
	await selectUpdateType();
}

main();
