class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.2.6.tar.gz"
  sha256 "639068e8973fc923d3451e5a81c56e0ce75e6b1f8c21849131be567fe6b39adf"

  bottle do
    sha256 "69a1cb10dbefbb9b60a2eb60336a0e87af8f2e5ee259dd132dd42d8418a6a032" => :catalina
    sha256 "44d92029c93a1f446d4dc7ccba56b3eeb1e65ebd26970f61d34d1f782edeab3c" => :mojave
    sha256 "e640d81f238cc1c375b950aa2c1e8a4bbe0c86291d493a0a056d8af7f01ef519" => :high_sierra
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
    bind = "tcp://127.0.0.1:8000"

    pid = fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    begin
      output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
      assert_match(/home/, output)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
