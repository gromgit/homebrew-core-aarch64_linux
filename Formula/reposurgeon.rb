class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
    tag:      "4.20",
    revision: "2470b8199c043a2710d6ef2c29767594509785d9"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8897b461798872fd9ad95c20bfeb2c6894ed64e66076ca483225a00a588ff08f" => :big_sur
    sha256 "4908754a4b24b8fafaecd258a35b0d4ea90696d66c32bc31c6d49a386836ec8a" => :catalina
    sha256 "90aff8ea40b411ed1cfbbe057fe19c7156ff77bb600b2b714467ce76d67e4b98" => :mojave
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("script -q /dev/null #{bin}/reposurgeon read list")
  end
end
