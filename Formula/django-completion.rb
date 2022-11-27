class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://github.com/django/django/archive/4.1.tar.gz"
  sha256 "438269e4a1021bcb67d71345d60c1b56163651a3b00f90dbdbb5d62f4819b87c"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/django-completion"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f7d339a49422da573ef1a74aa080e579ae346395b0c65349b15e8b52a8b5b99e"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin'")
  end
end
