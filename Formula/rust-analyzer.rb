class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-08-10.tar.gz"
  version "2020-08-10"
  sha256 "5aa91ced95650ccf7430db4ed314c9fe37553049ada05b28fa9ec20999328a79"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbb9298383cb3507a8ac158cecb5aa206e45088a2757d535d16f04a74c514cea" => :catalina
    sha256 "bf00b173eb903b8ee8434aabc64d965ccb1ccf8a67cda1ec6dd2e8edc6891fcf" => :mojave
    sha256 "b7c27ab01d74b63ddfb674b5a00b733f9a20c12b69809aaafa9f05e7ce6c2cdc" => :high_sierra
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
