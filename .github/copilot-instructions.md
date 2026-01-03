# Copilot Instructions for the Website Codebase

## Overview
This document provides essential guidance for AI coding agents working within this codebase. Understanding the architecture, workflows, and conventions is crucial for effective contributions.

## Architecture
- **Main Components**: The primary component is the `index.qmd` file, which serves as the entry point for the website. It contains metadata and content for the site.
- **Data Flow**: The website is structured to present research interests and professional background, with links to external resources like OECD, IDB, and FLAR.

## Developer Workflows
- **Building the Site**: Use Quarto to render the `.qmd` files into HTML. The command is `quarto render index.qmd`.
- **Testing**: Ensure that all links are functional and the layout is responsive across devices. Manual testing is required as there are no automated tests in place.

## Project-Specific Conventions
- **File Naming**: Use lowercase letters and hyphens for file names to maintain consistency.
- **Content Structure**: Follow the markdown structure for content, ensuring that headers and links are properly formatted.

## Integration Points
- **External Dependencies**: The website links to external institutions. Ensure that URLs are up-to-date and functional.
- **Cross-Component Communication**: Currently, there are no complex interactions between components, but future enhancements may require JavaScript for interactivity.

## Examples
- **Linking to External Resources**: Use markdown syntax for links, e.g., `[OECD](https://www.oecd.org/)`.
- **Adding New Content**: Follow the existing structure in `index.qmd` to add new sections or information.

## Conclusion
This document should be updated as the codebase evolves. Ensure that any changes to workflows or conventions are reflected here to maintain clarity for future AI agents.