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

  initialize: function() {
    this.collection = new Links(this.options.allLinks);
    this.currentLinkPosition = this.options.currentLinkPosition;
    this.render();
  },

  events: {
    'click ul.navigate-links a' : 'loadPage',
    'click span#prev'           : 'loadPrevPage',
    'click span#next'           : 'loadNextPage'
  },

  render: function() {
    var self = this;
    $(this.el).append("<ul class='navigate-links'></ul><span id='prev'>P</span><span id='next'>N</span>");  
    this.collection.forEach(function(link){
      self.appendLink(link);
    });
  },

  loadPage: function(){
    alert("Load Now");
  },

  loadNextPage: function(){
    var nth = (this.currentLinkPosition + 1) % this.collection.length;
    this.currentLinkPosition = nth;
    $('iframe').src(this.collection.at(nth).get('url'));
  },

  loadPrevPage: function(){
    var nth = this.currentLinkPosition;
    if (this.currentLinkPosition == 0 ){
      nth = this.collection.length; 
    }
    $('iframe').src(this.collection.at(nth).get('url'));
  },

  appendLink: function(link){
    $('ul.navigate-links', this.el).append("<li><a href='#'>" + link.get('title') + "</a></li>"); 
  }

});
