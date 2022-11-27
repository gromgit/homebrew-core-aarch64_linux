class Gwt < Formula
  desc "Google web toolkit"
  homepage "http://www.gwtproject.org/"
  url "https://github.com/gwtproject/gwt/releases/download/2.10.0/gwt-2.10.0.zip"
  sha256 "3be5fe11c27e8fd5a513eff8b14c2f26999faf4b991a8ad428f1916a36884427"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/gwtproject/gwt.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gwt"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5d76828e55f3bcef6a1947377b5089e89d9d6ec828b1736ecec00d56cf09a98d"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"] # remove Windows cmd files
    libexec.install Dir["*"]

    (bin/"i18nCreator").write_env_script libexec/"i18nCreator", Language::Java.overridable_java_home_env
    (bin/"webAppCreator").write_env_script libexec/"webAppCreator", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"webAppCreator", "sh.brew.test"
    assert_predicate testpath/"src/sh/brew/test.gwt.xml", :exist?
  end
end
