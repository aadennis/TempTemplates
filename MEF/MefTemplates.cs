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

// Full example in a single assembly:
//Program.cs
using System;
using System.ComponentModel.Composition.Hosting;
using System.ComponentModel.Composition;
using System.Reflection;

namespace MefTry01
{
    class Program {
       
        
        static void Main(string[] args) {
            var catalog = new AssemblyCatalog(Assembly.GetExecutingAssembly());
            var container = new CompositionContainer(catalog);

            var _house = new House();
            container.ComposeParts(_house);
            _house.EnableIOT();
            Console.ReadKey();
        }
    }
}

// House.cs
using System;
using System.ComponentModel.Composition;

namespace MefTry01
{
    class House {
        [Import]
        private Alarm _alarm;
        internal void EnableIOT() {
            Console.WriteLine("IOTing the house...");
            _alarm.Activate();
        }
    }
}

// Alarm.cs
using System;
using System.ComponentModel.Composition;

namespace MefTry01 { 
    [Export]
    class Alarm {
        internal void Activate() {
            Console.WriteLine("Alarm activated.");
        }
    }
}

// Expected output 
// IOTing the house...
// Alarm activated.
 
 
 
