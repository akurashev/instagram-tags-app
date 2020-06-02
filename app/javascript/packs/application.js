// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

$(() => {
  $('.js-tag-to-select').on('click', function() {
    const tag = $(this).text().trim()
    const old_text = $('.js-selected-tags').val()
    let counter = $('.js-tags-counter').text()
    let new_text = old_text

    if ($(this).hasClass('badge-dark')) {
      new_text = old_text.replace(tag, '')
      counter--
    } else {
      new_text = old_text.concat(' ', tag)
      counter++
    }
    $('.js-selected-tags').val(new_text.trim())
    $('.js-tags-counter').text(counter)

    $(this).toggleClass('badge-dark')
  })

  $('.js-selected-tags').on('focus', function() {
    $(this).select()
    document.execCommand("copy")
  })
})
