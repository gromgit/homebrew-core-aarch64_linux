class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.0.tar.gz"
  sha256 "2ab747b4b9187fec4922492c2ada936a64b71e1a2cb6d01c6b6a1db61ade2399"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c864fc789446ab47cf1774a07eb27606bfa2e91ad69eee2ae9077eb9532e47d5" => :catalina
    sha256 "2196a2f46a13a5842b9c7a207c2a37c0dbb027a4e8a26343828fa80518f0003d" => :mojave
    sha256 "456542e5dc64ce4d1bedd96519bd2b610b4098bb12854dc46abd4dac47776306" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
