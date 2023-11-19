---
layout: post
title: Spam Detection with Naive Bayesian Classifier
date: 2023-07-04 08:57:00-0400
description: a project in my first year data science course
tags: ml data-science
categories: data-science
giscus_comments: false
related_posts: false
---


{::nomarkdown}
{% assign jupyter_path = "assets/jupyter/spam-ham-bayes.ipynb" | relative_url %}
{% capture notebook_exists %}{% file_exists assets/jupyter/spam-ham-bayes.ipynb %}{% endcapture %}
{% if notebook_exists == "true" %}
    {% jupyter_notebook jupyter_path %}
{% else %}
    <p>Sorry, the notebook you are looking for does not exist.</p>
{% endif %}
{:/nomarkdown}