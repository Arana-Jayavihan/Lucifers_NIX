import { Bar } from "./simpleBar/bar.js";

App.config({
  style: "./simpleBar/style.css",
  windows: [
    Bar(0), 
    Bar(1)],
});
