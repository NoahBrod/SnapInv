import '../App.css'
import logo from '../snapinv_logo.png'

export const ProfilePage = () => {
    return (
        <div className='App'>
            <header className='App-header'>
                <img src={logo} className='App-logo'/>
                <p>
                    Welcome to SnapInv!
                </p>
                <a className='App-link' target='_blank' href=''>Join Today</a>
            </header>
        </div>
    );
}