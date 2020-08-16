class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.3.tar.gz"
  sha256 "b5a7f0badc4af936a6269730ec5af7872638207e2e93c02f7d81344f0f2527d4"
  license "MIT"
  revision 1
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a6625e193a7b9855eb6118d1e877555b36db27f57585b054181521c1747b66c" => :catalina
    sha256 "a5485298078b956514250d8d7f06beedc0ccfb303ba19bc5f78d7dd0712ca2f4" => :mojave
    sha256 "ac97dbc8b74e291860b6bffbed271c0460b27f13b500df7d0c5237ce0aa2f18a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/prestd" do
      system "go", "build", *std_go_args, "-ldflags",
            "-s -w -X github.com/prest/helpers.PrestVersionNumber=#{version}"
    end
  end

  test do
    output_regex = /Version (?<migration>\d+) migration files created in .*:/
    output = shell_output("prest migrate create test --path .")
    migration = output.match(output_regex)[:migration]
    assert_predicate testpath/"#{migration}_test.down.sql", :exist?
    assert_predicate testpath/"#{migration}_test.up.sql", :exist?
  end
end
