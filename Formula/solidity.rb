class Solidity < Formula
  desc "Contract-oriented programming language"
  homepage "https://soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.8/solidity_0.8.8.tar.gz"
  sha256 "d15827496f4baa47aceabfd2342370aad62a2042fa5d5e501b8138506b288e1d"
  license all_of: ["GPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0", "CC0-1.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "425d7f24bc9925acda01839e86d903071126527dc338539defb4620521feeb0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "66846e341b2ca3844f535220c87007e09cfe3b961c62035c303133fba3b05966"
    sha256 cellar: :any_skip_relocation, catalina:      "65c321dae33f2ccc2a8bac0707af73503dbbd7ce315defbfff3fc47cb06a61c0"
    sha256 cellar: :any_skip_relocation, mojave:        "fcb7a4e094933c31b52e20908edf4dee8c17e368004abbf36937c3644faa0faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e954e40eb90525794b9b670213474418ee0caf959cf90bc4ce30908906eed35f"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.0", :build]
  depends_on "boost"

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.sol").write <<~EOS
      // SPDX-License-Identifier: GPL-3.0
      pragma solidity ^0.8.0;
      contract HelloWorld {
        function helloWorld() external pure returns (string memory) {
          return "Hello, World!";
        }
      }
    EOS
    output = shell_output("#{bin}/solc --bin hello.sol")
    assert_match "hello.sol:HelloWorld", output
    assert_match "Binary:", output
  end
end
