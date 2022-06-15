class Qprint < Formula
  desc "Encoder and decoder for quoted-printable encoding"
  homepage "https://www.fourmilab.ch/webtools/qprint/"
  url "https://www.fourmilab.ch/webtools/qprint/qprint-1.1.tar.gz"
  sha256 "ffa9ca1d51c871fb3b56a4bf0165418348cf080f01ff7e59cd04511b9665019c"

  livecheck do
    url :homepage
    regex(/href=.*?qprint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/qprint"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f7b5c59e3000371980ab33aa3b35f4d29d0f70a4ea3497717e377c6e2f871385"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    msg = "test homebrew"
    encoded = pipe_output("#{bin}/qprint -e", msg)
    assert_equal msg, pipe_output("#{bin}/qprint -d", encoded)
  end
end
