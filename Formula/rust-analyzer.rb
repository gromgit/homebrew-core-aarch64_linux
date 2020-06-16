class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-06-15.tar.gz"
  sha256 "8d964ba82fd4d34287953f9654c79b5a4b2ed7ca0c710759ecc1d9e7d76bcd40"

  bottle do
    cellar :any_skip_relocation
    sha256 "98a426880296092ba657d6cb7515e22e3832cc49099d28ad8fc24f747665dd71" => :catalina
    sha256 "93dd0d3cd0fdf39c72e433e3858df2eaf2c9b543a32cd8aa29b62943f899bc9a" => :mojave
    sha256 "1ab0c1598271b6b2fab5e5f865facbe450cb65a02fa5d5a45adeb81953e2da3d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path",
           "crates/rust-analyzer", "--bin", "rust-analyzer"
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
