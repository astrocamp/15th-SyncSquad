import { Application } from "@hotwired/stimulus";
import ScrollReveal from "stimulus-scroll-reveal";

const application = Application.start();
application.register("scroll-reveal", ScrollReveal);

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
