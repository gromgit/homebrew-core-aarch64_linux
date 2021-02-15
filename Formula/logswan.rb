class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/2.1.9.tar.gz"
  sha256 "7957930e959a951707a7bdf614dbe5fa10be5d9c9c39ffd94b4ca1308615fe00"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d6bcc058eb4c8493ee6e9cc6314e2b27c860dca22eaebdea8a6fd2d9748d96e3"
    sha256 cellar: :any, big_sur:       "aec6e22b5e3f78e1ef3b09421c465a210c16101948603ee145d356f2f0f1c0fc"
    sha256 cellar: :any, catalina:      "38dab3a524aeb292bf163d472e3adfc5f349c4fc97b0e07f09a8a6d601535aa4"
    sha256 cellar: :any, mojave:        "9400f3fe332ce90fa3c0c6075ef42ba214742d0b1c3ccbc76161c60f02251ce9"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    assert_match "visits", shell_output("#{bin}/logswan #{pkgshare}/examples/logswan.log")
  end
end
