if (typeof browser === "undefined") {
    var browser = chrome;
}
try {

console.log("Starting up plugin loader...")

const script = document.createElement("script");
script.src = browser.runtime.getURL("dist/bundle.js");
// documentElement because we load before body/head are ready
document.documentElement.appendChild(script);

const style = document.createElement("link");
style.type = "text/css";
style.rel = "stylesheet";
style.href = browser.runtime.getURL("dist/bundle.css");

const extraStyle = document.createElement("link");
extraStyle.type = "text/css";
extraStyle.rel = "stylesheet";
extraStyle.href = browser.runtime.getURL("extr.css");

document.documentElement.append(script);

document.addEventListener(
    "DOMContentLoaded",
    () => {
	console.log("Appending stylesheets...")
	document.documentElement.append(style);
	document.documentElement.append(extraStyle); 
    },
    { once: true }
);

} catch(e){console.error(e)}
