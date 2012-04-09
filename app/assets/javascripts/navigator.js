$(function(){

  var LinkItem = Backbone.Model.extend({
    initialize: function(kv){
      var k = _.keys(kv)[0];
      this.set({ title: k});
      this.set({ url: kv[k]});
    }
  });

  var Links = Backbone.Collection.extend({
    model: LinkItem
  });

  var LinkNavigator = Backbone.View.extend({
    el: $('#topics-quick'),

    initialize: function() {
      this.count = 1;
      this.collection = new Links(this.options.allLinks);
      this.currentLinkPosition = this.options.currentLinkPosition;
      _.bindAll(this, "loadNextPage", "loadPrevPage");
      this.render();
    },

    events: {
      'click ul.navigate-links a' : 'loadPage',
    },

    render: function() {
      var self = this;
      $(this.el).append("<ul class='navigate-links h-dropdown'></ul>");
      $(this.el).append("");
      this.collection.forEach(function(link){
        self.appendLink(link);
      });
    },

    loadPage: function(event){
      var nth = $(event.target).data('idx');
      this.currentLinkPosition = nth;
      $('iframe').src(this.collection.at(nth-1).get('url'));   
    },

    loadNextPage: function(){
      var nth = this.currentLinkPosition + 1;
      if (nth == this.collection.length) {
        nth = 1;
      }
      console.log(nth);
      this.currentLinkPosition = nth;
      $('iframe').src(this.collection.at(nth-1).get('url'));
    },

    loadPrevPage: function(){
      var nth = this.currentLinkPosition - 1;
      if (nth == 0 ){
        nth = this.collection.length; 
      }
      console.log(nth);
      this.currentLinkPosition = nth;
      $('iframe').src(this.collection.at(nth-1).get('url'));
    },

    appendLink: function(link){
      $('ul.navigate-links', this.el).append("<li><a href='#' data-idx='"+ this.count +"'>" + link.get('title') + "</a></li>"); 
      this.count++;
    }
  });

  window.linknav = new LinkNavigator({
    currentLinkPosition: currentLinkPosition,
    allLinks: allLinks
  });

});
