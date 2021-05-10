class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-05-10",
       revision: "fd109fb587904cfecc1149e068814bfd38feb83c"
  version "2021-05-10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6632d644cb106254ca88f407a96c7f0e17b22aaa2547795f15367b8a9b2f766c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8f0a0a344b38633363622b2f54781143bfbe4f23c3345d43473fa91f95a4907"
    sha256 cellar: :any_skip_relocation, catalina:      "7ab4e95624ebf25b1ad20ac04a1174205e831cb6c30f188722df2040c17f09e9"
    sha256 cellar: :any_skip_relocation, mojave:        "2551e0180008ffcd87bcfb4bc4ce5945f07549836b6bb340dd018cd052c7bb0b"
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
