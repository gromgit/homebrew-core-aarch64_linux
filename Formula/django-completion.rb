class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://github.com/django/django/archive/4.0.7.tar.gz"
  sha256 "7b8abe5b8c32f716b5d3a8e17627e932e5c4f2eee0b3fbe5f79c42e3dc516e9a"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2beb747d4e6c09319d8dbb2e3fa6f3bb49a2f56226d9c0c6086a24f43512a55"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end
