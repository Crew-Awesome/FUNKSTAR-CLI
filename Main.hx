package;

class Main
{
  static var mods:Map<String, Mod> = [
    'qtrewired' => new Mod('QT: Rewired'),
    'funkin.remnants' => new Mod('Funkin\' Remnants'),
    'gooeymix' => new Mod('FNF: Gooey Mix'),
    'whitty.bonusweekend' => new Mod('VS Whitty: Bonus WeekEnd'),
    'sky.redux' => new Mod('Vs Sky Redux'),
    'hazier.river' => new Mod('Hazier River'),
    'pointlesspins' => new Mod('Pointless Pins', ['betteralphabet']),
    'betteralphabet' => new Mod('Better Alphabet')
  ];

  static function main()
  {
    var args = Sys.args();
    var cmd = args.shift();
    var noDependencies = false;
    var verbose = false;
    var modsToInstall = [];
    var engine = '';
    var dir = '';

    for (arg in args)
    {
      if (arg == '--no-dependencies')
      {
        noDependencies = true;
        continue;
      }

      if (arg == '--verbose')
      {
        verbose = true;
        continue;
      }

      if (cmd == 'install' || cmd == 'remove') modsToInstall.push(arg);

      if (cmd == 'setup')
      {
        if (engine == '') engine = arg;
        else
          dir = arg;
      }
    }

    var finalMods = [];
    for (mod in modsToInstall)
    {
      finalMods.push(mod);
      if (!noDependencies && mods.exists(mod)) finalMods = finalMods.concat(mods[mod].dependencies);
    }

    switch (cmd)
    {
      case 'install':
        Sys.println('Found ${finalMods.length} mod${finalMods.length == 1 ? '' : 's'} to install.');
        for (m in finalMods)
        {
          if (mods.exists(m)) m = mods[m].name;
          Sys.println('Installing $m...${verbose ? ' 100/100' : ''}');
          Sys.println('Installed $m!');
        }
      case 'remove':
        Sys.println('Found ${finalMods.length} mod${finalMods.length == 1 ? '' : 's'} to remove.');
        for (m in finalMods)
        {
          if (mods.exists(m)) m = mods[m].name;
          Sys.println('Removing $m...');
          Sys.println('Removed $m!');
        }
      case 'help':
        Sys.println('- setup
     - sets up funkSTAR, installs relevant mod dependencies
     - Arguments:
          - VSLICE
          - PSYCH
          - CNE
          - Requires filepath to engine installation.
- install
     - installs all mod ids after this argument
- remove
     - removes all mod ids after this argument
- --verbose
     - provides extra logs
- --no-dependencies
     - ignores dependencies when installing/removing mods');
      case 'setup':
        Sys.println('Setting up for ${engine} using directory ${dir}');
    }
  }
}

class Mod
{
  public var name:String;

  public var dependencies:Array<String>;

  public function new(name:String, ?dependencies:Array<String>)
  {
    this.name = name;
    this.dependencies = dependencies ?? [];
  }
}
