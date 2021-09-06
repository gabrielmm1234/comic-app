import debounce from 'lodash.debounce'

document.addEventListener("DOMContentLoaded", function (event) {
  const loadingWrapper = document.getElementById('loading-wrapper')
  const searchForm = document.getElementById('search-form')

  document.getElementById('search-input').addEventListener('input', debounce((event) => {
    window.scrollTo(0, 0)
    loadingWrapper.classList.remove('hidden')
    searchForm.submit()
  }, 800))

  $(".upvote-heart").click(function () {
    const comicId = $(this).parent().data('comicId');

    $.post("/vote",
      {
        vote_type: "up",
        comic_id: comicId
      },
      (data, status) => {
        if (status == "success") {
          $(this).parent().addClass("upvoted");
        }
      });
  });
});
