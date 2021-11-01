class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.18.0.tar.zst"
  sha256 "2a9e4e493947f36fa76b256c54dc8013eea45032a96a1b9f281965b0e6cf1fca"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ecc58979bd9e7ecd7c6c1c3f5bb4ebc02c18dc8fea9a788abea238d06558e311"
    sha256 cellar: :any_skip_relocation, big_sur:       "b04ccb951cf8996c18be2e35a7d4cc1981a18e6bb678b5647b48a1fdd4e4ef19"
    sha256 cellar: :any_skip_relocation, catalina:      "b04ccb951cf8996c18be2e35a7d4cc1981a18e6bb678b5647b48a1fdd4e4ef19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4e356b2ce03f66e057b6f7b3cd8ebc293234c7c0ff33cb921d36b080c3524d"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args, "-mod=vendor"
    end

    ENV.prepend_path "PATH", bin
    cd bin do
      system "goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
