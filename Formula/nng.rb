class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.3.1.tar.gz"
  sha256 "3f258514b6aed931485ce1a6e5745e07416d32e6c4315ae771ff358e9fd18e55"
  license "MIT"

  bottle do
    sha256 "89bba37c334ca7a130d598fb976f9c5f6c94d5a446ab665774cda9ae9224c9f9" => :catalina
    sha256 "5ead1d0ad461e09c9b72b0465d704a4b05186b698f9d7698f6e320e6bb6c9b1c" => :mojave
    sha256 "a636719676a386935f3d7006aedcd42183c84e139bc2edc5fa7cff6d735ab7a3" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", "-DNNG_ENABLE_DOC=ON", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(/home/, output)
  end
end
