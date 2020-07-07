class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-07-06.tar.gz"
  sha256 "f5c2febf5ad07b3c73ba96d4579fbc2511d5cf17c8aefbd5bbd7bb1378830d4e"

  bottle do
    cellar :any_skip_relocation
    sha256 "84c4d712170b890a2ae67bfc3ed3e0c6afae12e0b8a65e20a1209f134592e11d" => :catalina
    sha256 "59fd6cd2d4fed794ed0d635b3f048bfe20a4c6ddb44d3fd4ce7f649e1578bb91" => :mojave
    sha256 "b16b5d0193d85f89f6249b8063730779e7e039c6635b08392d77c7dddc9d47c7" => :high_sierra
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
