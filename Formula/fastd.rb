class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/NeoRaider/fastd"
  url "https://github.com/NeoRaider/fastd/releases/download/v19/fastd-19.tar.xz"
  sha256 "6054608e2103b634c9d19ecd1ae058d4ec694747047130719db180578729783a"
  head "https://github.com/NeoRaider/fastd.git"

  bottle do
    cellar :any
    sha256 "c9823ed23d53e35f3cbad486867d885e747c6c2e8e4da739cd27522fa3f0ab5b" => :catalina
    sha256 "81dbae981699f6be12675b2f3506071fd2fcc7928f8f1744ac76abb48a1c1104" => :mojave
    sha256 "19dc7f2bf518b8f9374fcfbc7e73fa0ca330d6eb23d92be4b6e2e6a5771fdc6d" => :high_sierra
    sha256 "e209a7908ab196c614fd8a21d76bfbfc8c73a699784834457e0c1da6eed24a43" => :sierra
    sha256 "e097588f07f37954bbb525e7f08a9d69dd9bb18bff63616aa942329f7fe15dc1" => :el_capitan
  end

  depends_on "bison" => :build # fastd requires bison >= 2.5
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_LTO=ON", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
