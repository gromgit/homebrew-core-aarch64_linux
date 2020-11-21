class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.70.0.tar.gz"
  sha256 "8f7ab2443c61b0c666e9ad629546361d69554a6af8682c0ac323802758c983a4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dac100a02de1b55e03b49fbb85a9d695826c15e3dee6eac3215bf6d1fae766a" => :big_sur
    sha256 "040a38088d607fab08dfa73665a9804eab45f42ffe108cfafd1df92355e123ca" => :catalina
    sha256 "ef3d2680cb8f713f5a328d49843a73065ca6eb947de7a48e9d76fac30691ccf8" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz -v 2>&1")
    (testpath/"config.toml").write <<~EOS
      proto = "greeter.proto"
      call = "helloworld.Greeter.SayHello"
      host = "0.0.0.0:50051"
      insecure = true
      [data]
      name = "Bob"
    EOS
    assert_match "open greeter.proto: no such file or directory",
      shell_output("#{bin}/ghz --config config.toml 2>&1", 1)
  end
end
