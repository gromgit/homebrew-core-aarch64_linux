class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.11.0.tar.zst"
  version "1.11.0"
  sha256 "c3102d39c9b733a251efabf1788d54df9d2e7679b5366ffb9f4bbad24d6c4166"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "162b6e022b5afaf2e8122af5f9afe9573d4ed0200107ccd67650bbbf27c0cc48"
    sha256 cellar: :any_skip_relocation, big_sur:       "d5443d3812abe763ad7c3647fbb3a0679f2c916c1c7c243a9a70c391a117dfb1"
    sha256 cellar: :any_skip_relocation, catalina:      "d5443d3812abe763ad7c3647fbb3a0679f2c916c1c7c243a9a70c391a117dfb1"
    sha256 cellar: :any_skip_relocation, mojave:        "d5443d3812abe763ad7c3647fbb3a0679f2c916c1c7c243a9a70c391a117dfb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf99d9cb452142d3c1771d741486e40c6ff0d32e5eba10e09b110494a19044b"
  end

  depends_on "go" => :build
  depends_on "zstd" => :build

  def install
    goredo_prefix = "goredo-#{version}"
    system "tar", "--use-compress-program", "unzstd", "-xvf", "#{goredo_prefix}.tar.zst"
    cd "#{goredo_prefix}/src" do
      system "go", "build", *std_go_args, "-mod=vendor"
    end
    cd bin do
      system "./goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
