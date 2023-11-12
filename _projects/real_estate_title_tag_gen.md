---
layout: page
title: AI generated title tags for the real estate industry
description: Work for Optimistics, involving generating optimised title tags for real estate companies
importance: 1
category: work
---

#### With this deliverable, I wanted to make the user experience as seamless as possible, especially for the average customer with no coding or AI experience.

That's why, I decided to challenge myself to implementing the whole workflow wholly in Google Sheets. Users input their data, tweak the OpenAI API call and modify and edit the generated tag all within one sheet. Nothing need be downloaded or enabled.

{% include figure.html path="assets/img/project_imgs/real_estate_title_tag_gen/screenshot.png" title="UI Screenshot" class="img-fluid rounded z-depth-1" %}
<div class="caption">
    UI Screenshot - sidebar called from a custom UI menu
</div>
 
The purpose of this stage of development is to harvest real world feedback from users on the generation process. One specification of the task was a further simplification to UX - the temperature parameter of the API call should be a choice of three options as opposed to a custom float value. This allows more control for interpreting results, as it limits the classification needed on what tweaks to the API call work.

I am looking forward to analysing the results and acting upon the feedback once this app is distributed to a select few customers.

Technologies Used
: Google AppScript, Bootstrap, jQuery
