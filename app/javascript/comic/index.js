import debounce from 'lodash.debounce'

document.addEventListener("DOMContentLoaded", function (event) {
  const loadingWrapper = document.getElementById('loading-wrapper')
  const searchForm = document.getElementById('search-form')

  document.getElementById('search-input').addEventListener('input', debounce((event) => {
    window.scrollTo(0, 0)
    loadingWrapper.classList.remove('hidden')
    searchForm.submit()
  }, 800))
});
