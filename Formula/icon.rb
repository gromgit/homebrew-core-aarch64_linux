class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.21b.tar.gz"
  version "9.5.21b"
  sha256 "5dd46cd4e868c75ff1b50de275f1ec06a09641afcb8c18b072333f97f86d3bcc"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/icon"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "af399a929306503ff962407089b6131ad31eb544927470d46e7e80b0d7ab8a46"
  end

  def install
    ENV.deparallelize
    target = if OS.mac?
      "posix"
    else
      "linux"
    end
    system "make", "Configure", "name=#{target}"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
