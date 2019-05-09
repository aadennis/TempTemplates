// (In references, include [System.ComponentModel.Composition])

//Main etc...
using System.ComponentModel.Composition.Hosting;
using System.ComponentModel.Composition;
using System.Reflection;

var catalog = new AssemblyCatalog(Assembly.GetExecutingAssembly());
var container = new CompositionContainer(catalog);

 foreach (var p in container.Catalog.Parts)
{
    Console.WriteLine(p.ToString());
}

   container.ComposeParts(_car);

// Classes requiring Exports and Imports

using System.ComponentModel.Composition;

//above the specific type
[Import]

// above the class (if appropriate)
[Export]