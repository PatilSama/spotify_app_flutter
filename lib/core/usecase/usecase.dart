abstract class UseCase<Types,Params>{

    Future<Types> call({Params params});
}