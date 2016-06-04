using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using LiveDemo.Models;
using Microsoft.AspNetCore.Mvc;

namespace LiveDemo.Controllers
{
    public class HomeController : Controller
    {
        private static readonly string[] WaysToSayNo =
        {
            "Unbelievably, no.",
            "Any day now.",
            "More patience required."
        };

        public IActionResult Index()
        {
            var index = new Random().Next(WaysToSayNo.Length);
            var model = new WayToSayNo(WaysToSayNo[index]);
            return View(model);
        }

        public IActionResult About()
        {
            ViewData["Message"] = "Your application description page.";

            return View();
        }

        public IActionResult Contact()
        {
            ViewData["Message"] = "Your contact page.";

            return View();
        }

        public IActionResult Error()
        {
            return View();
        }
    }
}
