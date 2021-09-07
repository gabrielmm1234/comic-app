import debounce from 'lodash.debounce'

const isTrue = value => value === "true"

document.addEventListener("DOMContentLoaded", function (event) {
  const loadingWrapper = document.getElementById('loading-wrapper')
  const searchForm = document.getElementById('search-form')

  document.getElementById('search-input').addEventListener('input', debounce((event) => {
    window.scrollTo(0, 0)
    loadingWrapper.classList.remove('hidden')
    searchForm.submit()
  }, 800))

  $(".upvote-heart").click(function ({ target }) {
    const comicId = $(target).parent().data('comicId');
    let vote_type
    if (isTrue($(target).parent().attr('data-upvoted'))) {
      vote_type = "down"
    } else {
      vote_type = "up"
    };
    $.post("/vote",
      {
        vote_type: vote_type,
        comic_id: comicId
      },
      (data, status) => {
        if (status === "success") {
          $(target).parent().attr("data-upvoted", !isTrue($(target).parent().attr('data-upvoted')));
        }
      });
  });
});
