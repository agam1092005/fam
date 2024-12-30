### Dynamic Container Components
- getBackgroundColor
    - Summary: This function checks if the card contains a bg_color key. If so, it converts the provided hex string into a Color object. If the key is absent, it returns a transparent color, ensuring that the card always has a background (either transparent or defined).

- getLeadingIcon
    - Summary: The function checks if the card contains an icon key, and if present, it retrieves the icon’s image URL and optionally adjusts the size based on the icon_size key. If no icon is defined, it returns null. This allows dynamic inclusion of images for icons in card layouts.

- getTrailingArrow
    - Summary: This function adds a forward arrow icon at the end of the card, often used for navigation. The size of the icon is adjustable through the icon_size property. It helps in creating cards with navigation indicators, such as arrows, to guide users through UI interactions.

- getBgImage
    - Summary: If the card contains a bg_image key with an image_type of "ext", this function will load and display a background image from the provided URL. The image is clipped, aligned to the top left, and uses rounded corners for a polished visual. If no valid background image is provided, it returns an empty widget.

- getMargin
    - Summary: This function returns an EdgeInsets.symmetric margin to create spacing between cards. It ensures that if there are multiple cards, horizontal margins are applied to separate them, making the layout cleaner. If there is only one card, no margin is added.

- getScrollable
    - Summary: Based on the is_scrollable flag in the card’s configuration, this function returns the appropriate scroll physics: ClampingScrollPhysics if the content is scrollable or NeverScrollableScrollPhysics if it is fixed in place. This controls how the card behaves within a scrollable list.

- getSmallCardWidth
    - Summary: This function calculates the width for small cards depending on whether the container is scrollable or not. If the card list is scrollable, each card gets half the screen width. Otherwise, the width is divided evenly based on the number of cards, ensuring that cards fit the screen while maintaining spacing.

- getCardGradient
    - Summary: This function generates a linear gradient for the card’s background, using color values specified in the bg_gradient key. The gradient is created by parsing the hex color strings and applying the specified rotation angle, allowing for custom-colored backgrounds with smooth transitions.

- getCta
    - Summary: This function generates Call-to-Action (CTA) buttons for the card, iterating over the cta list in the card data. Each button is styled with optional background and text colors, and when clicked, it opens the URL specified in the cta data. This allows the card to have interactive buttons for further actions like linking to a webpage or executing an app feature.

- getTitle
    - Summary: This function checks if the card contains a formatted_title key. If so, it formats the title text with the provided entities and alignment. Otherwise, it uses the plain title field. It ensures that the title is displayed with appropriate styling and alignment, supporting rich text formatting.

- getDesc
    - Summary: Similar to the getTitle function, this one checks for a formatted_description field in the card. If it exists, it formats the description with the provided entities and alignment. If not, it falls back to the plain description field. This function ensures the description is displayed correctly, with support for rich text formatting.

- launchCardUrl
    - Summary: This function checks if the card has a url key. If present, it attempts to launch the URL using launchUrl. This provides the functionality to open external links or resources directly from the card, such as a website or app link.


### Helper Functions
- getImageHeight
    - Summary: This function downloads an image from a URL, retrieves its dimensions, and calculates its height based on a provided desired width while maintaining the image’s aspect ratio.

- setHighRefreshRate
    - Summary: This function checks if the platform is Android and sets the refresh rate to the highest available, enhancing display smoothness and performance on supported devices.