class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-07-20.tar.gz"
  sha256 "0b2277f7e1a359c6a5ddf69ba1a8acda769dd2709b1b5b65117531ee56e6d734"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcc40340c26b466008a8f42c654d872c8eff3121e2b3c18e10299b6e8f5908b2" => :catalina
    sha256 "5729032e3e5ddd78df3568bfbc2450c345f502bc586227fb6397de99a4d3f1b7" => :mojave
    sha256 "ca50e9172f2892efcf6b9859ccbc8fd3294c541f3ad9e7929b752db60879f4c9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
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
      "params": null
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
