class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.67.0.tar.gz"
  sha256 "fa02b646d328a9693e320b428307266789b2fdd24d0d5e47babe8aef6b432ea4"

  bottle do
    sha256 "f3a6618ac71cde525880edcd1f74c84e6d5a24737e1ea726977b3575ee321ced" => :catalina
    sha256 "a3988b48e83aa38ea23ac6618880b4216b579c0d482fb61d9891e05f8ade9e49" => :mojave
    sha256 "c7644e6785311fc8f7bb3af0a666c5ab320cc343ce1160a356bf1773c2323a99" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", ".[all]"
    # NOTE: dvc depends on asciimatics, which depends on Pillow, which
    # uses liblcms2.2.dylib that causes troubles on mojave. See [1]
    # and [2] for more info. As a workaround, we need to simply
    # uninstall Pillow.
    #
    # [1] https://github.com/peterbrittain/asciimatics/issues/95
    # [2] https://github.com/iterative/homebrew-dvc/issues/9
    system libexec/"bin/pip", "uninstall", "-y", "Pillow"
    system libexec/"bin/pip", "uninstall", "-y", "dvc"
    venv.pip_install_and_link buildpath

    bash_completion.install "scripts/completion/dvc.bash" => "dvc"
    zsh_completion.install "scripts/completion/dvc.zsh"
  end

  test do
    system "#{bin}/dvc", "--version"
  end
end
