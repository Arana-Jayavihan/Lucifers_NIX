import { Bar, } from "./simpleBar/bar.ts";

App.config({
  style: "./simpleBar/style.css",
  windows: [
    Bar(0), 
    Bar(1),
  ]
});
