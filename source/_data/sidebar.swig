{% if theme.tag_cloud.enable %}
  {% if site.tags.length > 1 %}
  <script type="text/javascript" charset="utf-8" src="/js/tagcloud.js"></script>
  <script type="text/javascript" charset="utf-8" src="/js/tagcanvas.js"></script>
  <div class="widget-wrap">
      <div id="myCanvasContainer" class="widget tagcloud">
          <canvas width="250" height="250" id="resCanvas" style="width=100%">
              {{ list_tags() }}
          </canvas>
      </div>
  </div>
  {% endif %}
{% endif %}
