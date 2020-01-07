class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag      => "v1.12",
      :revision => "1f371947309c5ea6023b6d9065415697cbc75578"

  bottle do
    cellar :any
    sha256 "9c497518754565c12bff1f5ff06158fa7769895f7af52f50d059c4e9049bd6ba" => :catalina
    sha256 "186dd16c2fc9a965c56e5339f571489e99d9ccb29ca46769590fbd40c6c013f3" => :mojave
    sha256 "7934a26348e2fdcc1dd845e31ded1192b7556d0a8b76ba4733c7dacf0c7c755d" => :high_sierra
    sha256 "daabcc35c45501a1b431714f226dd5072ffe6b53b18ff7230904a3040c1c3c4e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old
  depends_on "python" # Requires python3 executable

  def install
    # Build mpy-cross before building the rest of micropython. Build process expects executable at
    # path buildpath/"mpy-cross/mpy-cross", so build it and leave it here for now, install later.
    cd "mpy-cross" do
      system "make"
    end

    cd "ports/unix" do
      system "make", "axtls"
      system "make", "install", "PREFIX=#{prefix}"
    end

    bin.install "mpy-cross/mpy-cross"
  end

  test do
    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~EOS
      import ffi

      libc = ffi.open("libc.dylib")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system bin/"mpy-cross", "ffi-hello.py"
    system bin/"micropython", "ffi-hello.py"
  end
end
