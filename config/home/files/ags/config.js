// watchexec --restart --wrap-process=none -- "ags -c ~/nixos/modules/hyprland/ags/config.js"
const main = '/tmp/ags/main.js';
const nix = JSON.parse(Utils.readFile(`/home/${Utils.USER}/.local/share/ags/nix.json`));

try {
    await Utils.execAsync([
        nix.bun, 'build', `${App.configDir}/src/main.ts`,
        '--outfile', main,
        '--external', 'resource://*',
        '--external', 'gi://*',
        '--external', 'file://*',
    ]);
    await import(`file://${main}`);
} catch (error) {
		console.log("nixData: ", nix);
    console.error(error);
    App.quit();
}
