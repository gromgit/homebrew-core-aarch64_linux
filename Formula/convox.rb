class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.41.tar.gz"
  sha256 "e542e4e3a0bc0a94f9f760fa33d4f531416ef0cda25b35e4e11a624025b1fbfc"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4d1dabda3af6d800bd0fbb30b7c22158b9dc1bf82fcb5b2771694e73eebe18b4" => :catalina
    sha256 "ccc972b964ef3335b5ff35cd85eab6e3b7ccb0f98e253974661af534dca66d73" => :mojave
    sha256 "9c6443319fbf465c5a9735dd569861c8bf3a943a0e7e694de763be7505d2268b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
