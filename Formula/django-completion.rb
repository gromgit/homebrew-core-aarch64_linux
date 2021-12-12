class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://github.com/django/django/archive/3.2.9.tar.gz"
  sha256 "2b3d2ec987006ae5e3cc0e9982d5cc944f4a4f9ce55c34ae719ff0b2982c567d"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b8ab5e55fda48098a64bc901532fd307aedc75031b527b8b78319af4ca8b465"
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("bash -c 'source #{bash_completion}/django && complete -p django-admin.py'")
  end
end
