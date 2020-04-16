class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.22.0/chapel-1.22.0.tar.gz"
  sha256 "57ba6ee5dfc36efcd66854ecb4307e1c054700ea201eff73012bd8b4572c2ce6"

  bottle do
    sha256 "7d6baf3f49c5957e4ec07dafa506c62cdb8ff602ded9745559639a1fe014a7f3" => :catalina
    sha256 "dafbcd02cd4abeece95a40f573a8ac778248de55f4ec5f054258087dcdcb08cc" => :mojave
    sha256 "444c892f2532e62600ca4edf7b36944b6fbd89924ce6f92edb8718b42f7aad9d" => :high_sierra
  end

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    # This is for mason
    ENV["CHPL_REGEXP"] = "re2"

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "chpldoc"
      system "make", "mason"
      system "make", "cleanall"
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    bin.install Dir[libexec/"bin/darwin-x86_64/*"]
    bin.env_script_all_files libexec/"bin/darwin-x86_64/", :CHPL_HOME => libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    ENV["CHPL_HOME"] = libexec
    cd libexec do
      system "util/test/checkChplInstall"
    end
  end
end
