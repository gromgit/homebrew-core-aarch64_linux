class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.4.tar.gz"
  sha256 "c1025c368c6276530416ef4027150439fe90dbe094199875605b6f9ecb5423c3"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ac343c6c877e71e720c54aa587b9ecaa523c2f519c27d38f3fcd0ec4ce27d610" => :catalina
    sha256 "cefb4b1a4f50e5ed2b5a97cf1abded81fc7d814a75af4542cfd230af941bb898" => :mojave
    sha256 "3bad786cdca119026b897588f5db24a6ddbe550f33ed58b7ff16c95400dfc25c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/prestd" do
      system "go", "build", *std_go_args, "-ldflags",
            "-s -w -X github.com/prest/helpers.PrestVersionNumber=#{version}"
    end
  end

  test do
    output = shell_output("prest migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prest version")
  end
end
