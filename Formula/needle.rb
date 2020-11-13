class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.16.2.2",
      revision: "1f8f8bce6a8b13106f8c679518ae96b03defc093"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "aa5b5f934e831d61d2d623324a48b0e47cab4de498e643fbbce2c52d9c060f0e" => :catalina
  end

  depends_on xcode: ["11.6", :build]
  depends_on xcode: "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
    bin.install "./Generator/bin/needle"
    libexec.install "./Generator/bin/lib_InternalSwiftSyntaxParser.dylib"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
