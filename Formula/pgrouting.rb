class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.3.2/pgrouting-3.3.2.tar.gz"
  sha256 "45ef56271fc451d38675b3c846c46ac5c784ccbb51fe6df77270f2bed095eb34"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/pgRouting/pgrouting.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "151793f043090e7300dab326939a0611a900b420e2ae369d84031d25fd98ed7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60fbb6bda0d8d542aaf5c3a07ce25d23de7bd0a8dfad39ccd80d99bd020b332c"
    sha256 cellar: :any_skip_relocation, monterey:       "7d94f7f46a681456703c8a46c204c89d954be716fd9b785bae1a8d97e23716b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d9384323835e65147ff62b6c3a8e2ff10b80c028743aac04d4022d330f9c810"
    sha256 cellar: :any_skip_relocation, catalina:       "cd9a422b6d885c5cfbef8ee2b6afe26525633dbe5477545fb7bdba89e54560f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b0acc620b1380a1e5be9182224a88e656b4b2f8cb228691a270cfe7df82923"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "postgis"
  depends_on "postgresql@14"

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    mkdir "stage"
    mkdir "build" do
      system "cmake", "-DPOSTGRESQL_PG_CONFIG=#{postgresql.opt_bin}/pg_config", "..", *std_cmake_args
      system "make"
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

    stage_path = File.join("stage", HOMEBREW_PREFIX)
    lib.install (buildpath/stage_path/"lib").children
    share.install (buildpath/stage_path/"share").children
  end

  test do
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'libpgrouting-#{version.major_minor}'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"pgrouting\" CASCADE;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
